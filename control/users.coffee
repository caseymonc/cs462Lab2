
module.exports = (User, Account) =>
	
	renderProfile: (req, res)=>
		Account.findById req.params.user_id, (err, user)=>
			limit = 1
			if req.session?.account? && req.params.user_id == req.session.account.foursquareId
				limit = 10
			options = 
				url: 'https://api.foursquare.com' + '/v2/users/'+req.params.user_id+'/checkins?oauth_token='+user.token+'&limit=' + limit
				json: true
			request options, (error, response, body)=>
				console.log JSON.stringify body
				res.render 'profile', {checkins: body.response.checkins.items, user: user, title: "Profile", logged_in: limit == 10}


	renderProfileList: (req, res)=>
		Account.getAllAccounts (err, accounts)=>
			logged_in = false
			if req.session?.account?
				logged_in = true
			res.render('profiles', {users: accounts, title: "Users", logged_in: logged_in})

 	login: (req, res)=>
 		res.redirect "/login" unless (req.body.username? and req.body.password)
		data = {username: req.body.username, password: req.body.password}
		User.findOrCreate data, (err, user, created)=>
			req.session.user = user
			if created or not user.foursquareId?
				return res.redirect '/login/foursquare'
			Account.findById user.foursquareId, (err, account)=>
				return res.redirect '/login/foursquare' if err? or not account?
				req.session.account = account
				console.log "Redirect /app"
				res.redirect '/app'

	logout: (req, res)=>
		if req.session?.user?
			delete req.session.user
		req.session.destroy()
		res.redirect '/login'

	loginFoursquare: (req, res)=>
		console.log "Redirect received /login/foursquare"
		ensureUserAuthenticated req, res, ()=>
			return res.redirect '/app' if req.session?.account?
			res.render('login_foursquare', {title: "Foursquare Login"})

	authCallback: (req, res)=>
		req.session.account = req.user
		req.session.user.foursquareId = req.user.foursquareId
		User.addAccount req.user.foursquareId, req.session.user.username, ()=>
			res.redirect '/app'

ensureAuthenticated= (req, res, next)->
	ensureUserAuthenticated req, res, ()->
  	ensureFoursquareAuthenticated req, res, next

ensureUserAuthenticated= (req, res, next)->
  return next() if req.session?.user?
  res.redirect '/login'

ensureFoursquareAuthenticated= (req, res, next)->
  console.log JSON.stringify req.user
  return next() if req.session?.account?
  res.redirect '/login/foursquare'

