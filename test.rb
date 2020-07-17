require 'html-proofer'

options = {
  assume_extension: true,
  check_img_http: true,
  empty_alt_ignore: true,
  allow_hash_href: true,
  http_status_ignore: [429],
  file_ignore: [ "/events/" ],
  url_ignore: [ "https://github.com/oVirt/.*/edit/.*" ],
  parallel: { in_processes: 8 }
}

HTMLProofer.check_directory("./_site", options).run
