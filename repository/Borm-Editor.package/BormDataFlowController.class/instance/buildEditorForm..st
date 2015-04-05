as yet unclassified
buildEditorForm: aForm
	super buildEditorForm: aForm.
	aForm
		addDropList: 'type'
		label: 'Type'
		with: [ :dropList | 
			dropList
				items: #(#input #output);
				displayBlock: [ :type | type asString ];
				setSelectedItem: self model type;
				whenSelectedItemChanged: [ :newValue | self model type: newValue ] ]