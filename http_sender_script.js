// HTTP Sender Script
// URL: https://devonblog.com/continuous-delivery/owasp-zap-for-apis-using-custom-script-based-authentication/

function sendingRequest(msg, initiator, helper) 
{
	// Debugging can be done using println like this

	print(‘sendingRequest called for url=’ + msg.getRequestHeader().getURI().toString());
//	var loginToken=org.zaproxy.zap.extension.script.ScriptVars.getGlobalVar(“logintoken”);
	var loginToken=org.zaproxy.zap.extension.script.ScriptVars.getGlobalVar(“cwsauthtoken”);

//	var clientId=org.zaproxy.zap.extension.script.ScriptVars.getGlobalVar(“clientid”);
//	var tenantId=org.zaproxy.zap.extension.script.ScriptVars.getGlobalVar(“tenantid”);
	print(“clientId value: “+clientId);

	//set http header
	var httpRequestHeader = msg.getRequestHeader();
//	httpRequestHeader.setHeader(“Authorization: CWSAuth bearer=“+loginToken);
	httpRequestHeader.setHeader(“Authorization: CWSAuth bearer=“+cwsauthtoken);
//	httpRequestHeader.setHeader(“X-Client-Id”,clientId);
	msg.setRequestHeader(httpRequestHeader);
}

function responseReceived(msg, initiator, helper)
{
	// Debugging can be done using println like this
	print(‘responseReceived called for url=’ + msg.getRequestHeader().getURI().toString())
}
