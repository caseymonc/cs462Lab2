module.exports = () =>
	emitEvent: (url, domain, name, data)=>
		console.log "Emit Event"
		console.log "Url: " + url
		console.log "domain: " + domain
		console.log "name: " + name
		console.log "data: " + data
