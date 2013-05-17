# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_facility_dashboard_session',
  :secret      => '683e22226b875d2edc894e1b603dbda2a56d57cc88f59193f0e02dc4f7fd7fe794d8b97521f37415d405bc11006aaf9dac6ddbe1643bc1e5d3ca23407bb07b87'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
