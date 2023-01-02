extends HTTPRequest

func gen_link(base,nv,nn,type='la'):
	return base + nv + "/" + nn + "/Acknowledge/" + type

func get_data(node_v,node_n,type_da='la'):
	#var onem2mbase = "http://onem2m.iiit.ac.in:443/~/in-cse/in-name/"
	#var onem2mbase = "https://onem2m.iiit.ac.in/~/in-cse/in-name/"
	var onem2mbase = "https://onem2m.iiit.prashantnook.in/~/in-cse/in-name/"
	var headers = ['X-M2M-Origin: guest:guest',
		'Accept: application/json']
	var body = null
	var res = request(gen_link(onem2mbase,node_v,node_n,type_da),headers)
	if res != OK:
		push_error("An error occurred in the HTTP request.")

	

