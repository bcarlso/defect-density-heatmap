Defect Density Heatmap - Visualizing Code Churn
-----------------------------------------------

This is the defect density heatmap and it is used to identify files in your codebase that change often as a result of working on features and fixing defects. Before using the heatmap generator some background information is needed.

In our day to day development efforts we often commit code to our repository and give it a commit message. What if we add an additional piece of information to our commit message, such as a discriminator, identifying whether this change was related to a feature or defect? It can be anything, like starting the commit message with an 'F' or 'D'. If you're in corporate IT, your auditors would love it if you put ticket numbers in your commits (such as FEA-1234, DEF-1234)

Take a simple example:

	# ListController.java, ColumnSorter.js, ListView.jsp, ListRepository.java
	git commit -m 'f Adding clickable column headings for sorting'

	# ListController.java, ColumnSorter.js
	git commit -m 'd Prevented NPE when invalid product code filter entered'

	# ListController.java, ListView.jsp
	git commit -m 'd Fix spelling error'
	
This simple practice can give us some interesting insights into our code. Doing a bit of log crunching we can end up with a list of total changes and total defects a given file is associated with:

	# change-data.csv
	1,0,src/main/java/com/example/ListRepository.java
	3,2,src/main/java/com/example/ListController.java
	2,1,src/main/webapp/ListView.jsp
	2,1,src/main/webapp/js/ColumnSorter.js
	
In this example, the first column is the total number of changes and the second column is the number of defects this file was involved with.

Using the heatmap generator, we can create a tag cloud giving us a visualization of our code over time. The heatmap can be invoked in the usual ways:

	cat change-data.csv | heatmap > results.html
	heatmap -f change-data.csv -o results.html

The command renders a tag cloud formatted as HTML. The larger the text, the more that source file has changed. The text color changes from black to red based on the ratio of defects to changes. The more defects, the more red you see. Big + Red = Bad

![Heatmap Screenshot](https://github.com/bcarlso/defect-density-heatmap/raw/master/screenshot.png)