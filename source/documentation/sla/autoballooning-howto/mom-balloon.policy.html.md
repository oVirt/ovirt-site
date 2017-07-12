---
title: mom-balloon.policy
authors: aglitke
---

# mom-balloon.policy

Copy the contents of the box below to /etc/vdsm/mom-balloon.policy on the hypervisor host.

    ### KSM ########################################################################

    ### Constants
    # The number of pages to add when increasing pages_to_scan
    (defvar ksm_pages_boost 300)

    # The number of pages to subtract when decreasing pages_to_scan
    (defvar ksm_pages_decay -50)

    # The min and max number of pages to scan per cycle when ksm is activated
    (defvar ksm_npages_min 64)
    (defvar ksm_npages_max 1250)

    # The number of ms to sleep between ksmd scans for a 16GB system.  Systems with
    # more memory will sleep less, while smaller systems will sleep more.
    (defvar ksm_sleep_ms_baseline 10)

    # A virtualization host tends to use most of its memory for running guests but
    # a certain amount is reserved for the host OS, non virtualization-related work,
    # and as a failsafe.  When free memory (including memory used for caches) drops
    # below this parcentage of total memory, the host is deemed under pressure. and
    # KSM will be started to try and free up some memory.
    (defvar ksm_free_percent 0.20)

    ### Helper functions
    (def change_npages (delta)
    {
        (defvar newval (+ Host.ksm_pages_to_scan delta))
        (if (> newval ksm_npages_max) (set newval ksm_npages_max) 1)
        (if (< newval ksm_npages_min) (set newval ksm_npages_min) 0)
        (Host.Control "ksm_pages_to_scan" newval)
    })

    ### Main Script
    # Methodology: Since running KSM does incur some overhead, try to run it only 
    # when necessary.  If the amount of committed KSM shareable memory is high or if
    # free memory is low, enable KSM to try to increase free memory.  Large memory
    # machines should scan more often than small ones.  Likewise, machines under
    # memory pressure should scan more aggressively then more idle machines.

    (defvar ksm_pressure_threshold (* Host.mem_available ksm_free_percent))
    (defvar ksm_committed Host.ksm_shareable)

    (if (and (< (+ ksm_pressure_threshold ksm_committed) Host.mem_available)
             (> (Host.StatAvg "mem_free") ksm_pressure_threshold))
        (Host.Control "ksm_run" 0)
        {        # else
            (Host.Control "ksm_run" 1)
            (Host.Control "ksm_sleep_millisecs"
                (/ (* ksm_sleep_ms_baseline 16777216) Host.mem_available))
           (if (< (Host.StatAvg "mem_free") ksm_pressure_threshold)
                (change_npages ksm_pages_boost)
               (change_npages ksm_pages_decay))
        }
    )
    ### Auto-Balloon ###############################################################

    ### Constants
    # If the percentage of host free memory drops below this value
    # then we will consider the host to be under memory pressure
    (defvar pressure_threshold 0.20)

    # If pressure threshold drops below this level, then the pressure
    # is critical and more aggressive ballooning will be employed.
    (defvar pressure_critical 0.05)

    # This is the minimum percentage of free memory that an unconstrained
    # guest would like to maintain
    (defvar min_guest_free_percent 0.20)

    # Don't change a guest's memory by more than this percent of total memory
    (defvar max_balloon_change_percent 0.05)

    # Only ballooning operations that change the balloon by this percentage
    # of current guest memory should be undertaken to avoid overhead
    (defvar min_balloon_change_percent 0.0025)

    ### Helper functions
    # Check if the proposed new balloon value is a large-enough
    # change to justify a balloon operation.  This prevents us from
    # introducing overhead through lots of small ballooning operations
    (def change_big_enough (guest new_val)
    {
        (if (> (abs (- new_val guest.balloon_cur))
               (* min_balloon_change_percent guest.balloon_cur))
            1 0)
    })

    (def shrink_guest (guest)
    {
        # Determine the degree of host memory pressure
        (if (<= host_free_percent pressure_critical)
            # Pressure is critical:
            #   Force guest to swap by making free memory negative
            (defvar guest_free_percent (+ -0.05 host_free_percent))
            # Normal pressure situation
            #   Scale the guest free memory back according to host pressure
            (defvar guest_free_percent (* min_guest_free_percent
                                        (/ host_free_percent pressure_threshold))))

        # Given current conditions, determine the ideal guest memory size
        (defvar guest_used_mem (- (guest.StatAvg "balloon_cur")
                                  (guest.StatAvg "mem_unused")))
        (defvar balloon_min (+ guest_used_mem
                               (* guest_free_percent guest.balloon_cur)))
        # But do not change it too fast
        (defvar balloon_size (* guest.balloon_cur
                                (- 1 max_balloon_change_percent)))
        (if (< balloon_size balloon_min)
            (set balloon_size balloon_min)
            0)
        # Set the new target for the BalloonController.  Only set it if the
        # value makes sense and is a large enough change to be worth it.   
        (if (and (<= balloon_size guest.balloon_cur)
                (change_big_enough guest balloon_size))
            (guest.Control "balloon_target" balloon_size)
            0)
    })

    (def grow_guest (guest)
    {
        # There is only work to do if the guest is ballooned
        (if (< guest.balloon_cur guest.balloon_max) {
            # Minimally, increase so the guest has its desired free memory
            (defvar guest_used_mem (- (guest.StatAvg "balloon_cur")
                                      (guest.StatAvg "mem_unused")))
            (defvar balloon_min (+ guest_used_mem (* min_guest_free_percent
                                                     guest.balloon_max)))
            # Otherwise, increase according to the max balloon change
            (defvar balloon_size (* guest.balloon_cur
                                    (+ 1 max_balloon_change_percent)))

            # Determine the new target for the BalloonController.  Only set
            # if the value is a large enough for the change to be worth it. 
            (if (> balloon_size guest.balloon_max)
                (set balloon_size guest.balloon_max) 0)
            (if (< balloon_size balloon_min)
                (set balloon_size balloon_min) 0)
            (if (change_big_enough guest balloon_size)
                (guest.Control "balloon_target" balloon_size) 0)
        } 0)
    })

    ### Main script
    # Methodology: The goal is to shrink all guests fairly and by an amount
    # scaled to the level of host memory pressure.  If the host is under
    # severe pressure, scale back more aggressively.  We don't yet handle
    # symptoms of over-ballooning guests or try to balloon idle guests more
    # aggressively.  When the host is not under memory pressure, slowly
    # deflate the balloons.

    (defvar host_free_percent (/ (Host.StatAvg "mem_free") Host.mem_available))
    (if (< host_free_percent pressure_threshold)
        (with Guests guest (shrink_guest guest))
        (with Guests guest (grow_guest guest)))
