## File managed by Puppet
#
# This file was generated by 'rake generate_secret_token', and should
# not be made visible to public.
# If you have a load-balancing Redmine cluster, you will need to use the
# same version of this file on each machine. And be sure to restart your
# server when you modify this file.
#
# Your secret key for verifying cookie session data integrity. If you
# change this key, all old sessions will become invalid! Make sure the
# secret is at least 30 characters and all random, no regular words or
# you'll be exposed to dictionary attacks.
RedmineApp::Application.config.secret_key_base = 'eb39c1b01b81bcab9e481efcf9e8a0d6ba4dd97b30af1b1c886bd03dd6de72669e067c04f3b12b59'