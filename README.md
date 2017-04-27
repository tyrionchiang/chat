# chat






<p>
<img width = 120, src = "http://i.imgur.com/w1zrm8l.png"/><br/>
<img src="http://i.giphy.com/xUA7b9hZSMGP5AH5g4.gif" width = 120 />
<img src = "http://i.imgur.com/bHgYeXc.png", style = "float:right; width:570px">
</p>





# FireBase Database
-message
	-(messageID)
		fromID : String
		text : String
		timestamp : NSNumber
		toId : String
-user-messages
	-(userID)
		-(toUserID)
			-(messagesID)
-users
	-(userID)
		email : String
		name : String
		profileImageUrl : String
