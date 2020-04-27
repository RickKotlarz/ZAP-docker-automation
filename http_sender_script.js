// HTTP Sender Script
// URL: https://devonblog.com/continuous-delivery/owasp-zap-for-apis-using-custom-script-based-authentication/
function sendingRequest(msg, initiator, helper) {
	// Replace the ey-token-adsf.123.456 string below with the CWSAuth bearer token or a variable that contains this data
	msg.getRequestHeader().setHeader("Authorization\: CWSAuth bearer\=\"ey-token-adsf.123.456\"\nDynamic-Application-Security-Testing-ZAP-Initiator", initiator);
}

function responseReceived(msg, initiator, helper) {
	// Nothing to do here
}
