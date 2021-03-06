Class {
	#name : #OPBormStateController,
	#superclass : #OPBormProcessNodeController,
	#category : #'OpenPonk-BormEditor-Controllers'
}

{ #category : #hooks }
OPBormStateController >> buildEditorForm: aForm [
	super buildEditorForm: aForm.
	(aForm addCheckbox: 'Initial')
		state: self model isInitial;
		whenChangedDo: [ :newValue | 
			self model isInitial: newValue.
			self refreshFigure ].
	(aForm addCheckbox: 'Final')
		state: self model isFinal;
		whenChangedDo: [ :newValue | 
			self model isFinal: newValue.
			self refreshFigure ]
]

{ #category : #testing }
OPBormStateController >> canBeSourceFor: aController [
	^ aController isKindOf: OPBormTransitionController
]

{ #category : #testing }
OPBormStateController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPBormTransitionController) and: [ aController source isKindOf: OPBormActivityController ]
]

{ #category : #construction }
OPBormStateController >> figureClass [
	^ BormStateFigure
]

{ #category : #accessing }
OPBormStateController >> modelClass [
	^ BormState
]
