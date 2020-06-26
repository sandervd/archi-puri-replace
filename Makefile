# Updates the links to ABBs to their persistent URIs.
update_views: substitutions.sh viewslist.txt
	xargs -n1 -P8 -a viewslist.txt ./substitutions.sh

substitutions.sh: filelist.txt generate_substitutions.sh
	echo "#!/bin/bash" > substitutions.sh
	echo "cd html_report" >> substitutions.sh
	chmod +x substitutions.sh
	cat filelist.txt | xargs -i -P8 ./generate_substitutions.sh {} >> substitutions.sh

viewslist.txt: filelist.txt
	grep 'views' filelist.txt > viewslist.txt

filelist.txt: setup
	xmllint --html --xmlout html_report/index.html 2>&- |xmllint --xpath '//*[@class="tree-element"]/a/@href' - | grep -oP 'href="\K([a-zA-Z0-9\/.-]*)(?=")' | sort | uniq > filelist.txt

download:
	curl https://joinup.ec.europa.eu/sites/default/files/distribution/access_url/2019-03/22cb8062-887b-49be-afcd-23c3c4defc90/EIRA_v3_0_0_html.zip -o EIRA.zip
setup: download
	unzip EIRA.zip
	mv 'EIRA v3_0_0.html' 'html_report'

clean:
	rm -rf filelist.txt viewslist.txt substitutions.sh EIRA.zip html_report
