extends HTTPRequest

func gen_link(base,nv,nn,type='?rcn=4'):
	var link = base + nv + "/" + nn + "/Data" + type
	print(link)
	return link

func get_data(node_v,node_n,type_da='la'):
	#var onem2mbase = "http://onem2m.iiit.ac.in:443/~/in-cse/in-name/"
	#var onem2mbase = "https://onem2m.iiit.ac.in/~/in-cse/in-name/"
	var onem2mbase = "https://onem2m.iiit.prashantnook.in/~/in-cse/in-name/"
	
	var headers = [
		'X-M2M-Origin: guest:guest',
		'Accept: application/json',
		"Access-Control-Allow-Credentials: true",
		"Access-Control-Allow-Origin: *"
		]
		
	var body = null
	var link = gen_link(onem2mbase,node_v,node_n)
	var res = request(link,headers)
	if res != OK:
		push_error("An error occurred in the HTTP request.")

func _on_HTTPRequest_request_completed(result, _response_code, _headers, body):
	var response =  parse_json(body.get_string_from_utf8())
	if(typeof(response)==TYPE_DICTIONARY):
		get_parent().data = response["m2m:cnt"]
		get_parent().get_node("Control/WindowDialog/RichTextLabel").text =  str(response["m2m:cnt"])
		get_parent().get_node("Control/logo/Panel/VBoxContainer/Status/status").text = "Online"
		get_parent().get_node("Control/logo/Panel/VBoxContainer/LastEpoch").visible = true
		var labels = response["m2m:cnt"]["lbl"]
		
		var tree = get_parent().get_node("Control/logo/Panel/VBoxContainer/Tree")
		var root = tree.create_item()
		root.set_text(0,"Data")
		for i in labels:
			var item = tree.create_item(root)
			item.set_text(0, i)
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
