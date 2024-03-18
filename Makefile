SHELL:=/bin/sh
.SILENT:

.PHONY: readme hooks init
readme:
	curl -sLo .docs/footer.md https://gist.githubusercontent.com/jbonnier/b912640fd05fc9595d6894d2d7f7fce6/raw/jblab-common-footer-template.md
	terraform-docs markdown --config .docs/terraform-docs.yaml .

hooks:
	cp .githooks/pre-commit .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

init:
	rm -rf .git && git init
	$(MAKE) hooks
	curl -sLo .docs/header.md https://gist.githubusercontent.com/jbonnier/b912640fd05fc9595d6894d2d7f7fce6/raw/jblab-terraform-module-header-template.md
	echo -n "Repository name: "; \
	read REPO_NAME; \
	echo -n "GitHub Organization/User: "; \
	read GH_USER; \
	echo "Choose a license:"; \
	echo "  1) MIT"; \
	echo "  2) GPLv3"; \
	echo "  3) Apache 2.0"; \
	read LICENSE_CHOICE; \
	case $$LICENSE_CHOICE in \
		1) \
			LICENSE="MIT" ; \
			rm -f LICENSE_GPLv3 ; \
			rm -f LICENSE_Apache-2.0 ; \
			mv LICENSE_MIT LICENSE ;;\
		2) \
			LICENSE="GPLv3" ; \
			rm -f LICENSE_MIT ; \
			rm -f LICENSE_Apache-2.0 ; \
			mv LICENSE_GPLv3 LICENSE ;; \
		3) \
			LICENSE="Apache%202.0" ; \
			rm -f LICENSE_GPLv3 ; \
			rm -f LICENSE_MIT ; \
			mv LICENSE_Apache-2.0 LICENSE ;; \
		*) \
		echo "Invalid choice" ;; \
	esac; \
	echo -n "Author (for copyrights): "; \
	read AUTHOR; \
	YEAR=$(shell date +%Y); \
	sed -i "s/{{REPO_NAME}}/$$REPO_NAME/g" .docs/header.md; \
	sed -i "s/{{REPO_URL}}/$$GH_USER\/$$REPO_NAME/g" .docs/header.md; \
	sed -i "s/{{LICENSE}}/$$LICENSE/g" .docs/header.md; \
	sed -i "s/{{YEAR}}/$$YEAR/g" LICENSE; \
	sed -i "s/{{AUTHOR}}/$$AUTHOR/g" LICENSE; \
	sed -i "s/{{REPO_NAME}}/$$REPO_NAME/g" LICENSE
	mv Makefile.dist Makefile
