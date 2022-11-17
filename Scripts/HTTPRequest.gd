extends HTTPRequest

func gen_link(base,nv,nn,type='la'):
	return base + nv + "/" + nn + "/Data?rcn=4"

func get_data(node_v,node_n,type_da='la'):
	var onem2mbase = "http://onem2m.iiit.ac.in:443/~/in-cse/in-name/"
	var headers = ['X-M2M-Origin: guest:guest',
		'Accept: application/json']
	print("onem2m Loaded")
	var body = null
	var res = request(gen_link(onem2mbase,node_v,node_n,type_da),headers)
	if res != OK:
		push_error("An error occurred in the HTTP request.")

func _on_HTTPRequest_request_completed(result, _response_code, _headers, body):
	var response =  parse_json(body.get_string_from_utf8())
	if(typeof(response)==TYPE_DICTIONARY):
		var label = response["m2m:cnt"]["lbl"]
		var dlist = response["m2m:cnt"]["m2m:cin"]
		var processed = process_data(dlist,label)
		get_parent().data = {
			"labels":label,
			"data":processed
		}
	else:
		get_parent().get_node('Control/err/RichTextLabel').text = "OneM2M Server has not responded\n" + str(response)
		get_parent().get_node('Control/err').popup_centered()
		
func strtolist(tstr):
	return tstr.replace("[","").replace("]","").split(',')
	
func process_data(data,labels):
	labels = labels
	var ret = []
	var indx = 0
	for ri in data:
		var dat = strtolist(ri["con"])
		ret.append(dat)
	return ret
