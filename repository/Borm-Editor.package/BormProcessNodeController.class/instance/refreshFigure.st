hooks
refreshFigure
	(figure attributeAt: #RTLabelledLabel) text: self model name.
	(figure attributeAt: #RTLabelledLabel) pushFront.
	figure update.
	figure view signalUpdate