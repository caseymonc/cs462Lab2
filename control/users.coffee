request = require "request"

module.exports = (User, Account) =>
	
	renderProfile: (req, res)=>
		console.log 'Endpoint: Profile'
		Account.findById req.params.user_id, (err, user)=>
			limit = 1
			if req.session?.account? && req.params.user_id == req.session.account.foursquareId
				limit = 10
			options = 
				url: 'https://api.foursquare.com' + '/v2/users/'+req.params.user_id+'/checkins?oauth_token='+user.token+'&limit=' + limit
				json: true
			request options, (error, response, body)=>
				console.log JSON.stringify body
				return res.render 'profile', {checkins: body.response.checkins.items, user: user, title: "Profile", logged_in: limit == 10}

 	login: (req, res)=>
 		console.log 'Endpoint: Login'
 		res.redirect "/login"# unless (req.body.username? and req.body.password)
		

	renderProfileList: (req, res)=>
		console.log 'Endpoint: Profile List'
		Account.getAllAccounts (err, accounts)=>
			logged_in = false
			if req.session?.account?
				logged_in = true
			return res.render('profiles', {users: accounts, title: "Users", logged_in: logged_in})

	logout: (req, res)=>
		console.log 'Endpoint: Logout'
		if req.session?.user?
			delete req.session.user
		req.session.destroy()
		return res.redirect '/login'

	loginFoursquare: (req, res)=>
		console.log 'Endpoint: Login Foursquare'
		ensureUserAuthenticated req, res, ()=>
			return res.redirect '/app' if req.session?.account?
			return res.render('login_foursquare', {title: "Foursquare Login"})

	authCallback: (req, res)=>
		console.log 'Endpoint: Auth Callback'
		req.session.account = req.user
		req.session.user.foursquareId = req.user.foursquareId
		User.addAccount req.user.foursquareId, req.session.user.username, ()=>
			return res.redirect '/app'

ensureAuthenticated = (req, res, next)->
	ensureUserAuthenticated req, res, ()->
		ensureFoursquareAuthenticated req, res, next

ensureUserAuthenticated = (req, res, next)->
	console.log 'Try Auth Login'
	return next() if req.session?.user?
	res.redirect '/login'

ensureFoursquareAuthenticated = (req, res, next)->	
	console.log 'Try Auth Foursquare'
	return next() if req.session?.account?
	res.redirect '/login/foursquare'


