# see https://github.com/oVirt/ovirt-site/pull/2505
# borrowed from https://github.com/guard/listen/issues/339#issue-101785791
require 'listen/record/symlink_detector'
module Listen
  class Record
    class SymlinkDetector
      def _fail(_, _)
        # don't warn, noisy
        # keep the exception to skip listing on the symlink target in _fast_build_dir()
        raise ::Listen::Error::SymlinkLoop, 'Failed due to looped symlinks'
      end
    end
  end
end
