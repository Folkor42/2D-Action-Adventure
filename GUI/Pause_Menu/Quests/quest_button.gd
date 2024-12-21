class_name QuestItem extends Button

var quest : Quest

@onready var title_label: Label = $TitleLabel
@onready var step_label: Label = $StepLabel

func initalize( q_data : Quest, q_state : Dictionary ) -> void:
	quest = q_data
	title_label.text = quest.title
	
	if bool( q_state.is_complete ):
		step_label.text = "Completed"
		step_label.modulate = Color.LIGHT_GREEN
	else:
		var step_count : int = q_data.steps.size()
		var completed_count : int = q_state.completed_steps.size()
		step_label.text = str(completed_count)+"/"+str(step_count)
	pass
