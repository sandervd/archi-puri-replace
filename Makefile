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

filelist.txt: html_report
	xmllint --html --xmlout html_report/index.html 2>&- |xmllint --xpath '//*[@class="tree-element"]/a/@href' - | grep -oP 'href="\K([a-zA-Z0-9\/.-]*)(?=")' | sort | uniq > filelist.txt

html_report: EIRA.archimate
	Archi -application com.archimatetool.commandline.app -consoleLog -nosplash --loadModel EIRA.archimate --html.createReport html_report 2> /dev/null

clean:
	rm -rf filelist.txt viewslist.txt substitutions.sh EIRA.zip html_report
