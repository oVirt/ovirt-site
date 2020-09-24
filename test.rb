require 'html-proofer'

options = {
  assume_extension: true,
  check_img_http: true,
  check_html: true,
  empty_alt_ignore: true,
  disable_external: true,
  allow_hash_href: true,
  check_opengraph: true,
  only_4xx: true,
  http_status_ignore: [429],
  file_ignore: [ "/events/" ],
  url_ignore: [ "https://github.com/oVirt/.*/edit/.*" ],
  parallel: { in_processes: 8 }
}

HTMLProofer.check_directory("./_site", options).run
