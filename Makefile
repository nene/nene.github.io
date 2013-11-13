# Compiles CSS with LESS.
#
# To get less:
#
#   $ [sudo] npm install -g less
#
target less:
	lessc -x assets/less/main.less > assets/css/main.min.css
	lessc -x assets/less/ie.less > assets/css/ie.min.css
