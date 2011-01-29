# Swiped and adulterated from pdxrails' deploy.rb file

PointlessHash = {
  'hello' => 'world',
  'goodbye' => 'hello',
  'everybody wants' => 'rule the world',
  'world' => 'gone mad',
  'sun 1.0' => 'mass of incandescent gas',
  'sun 2.0' => 'miasma of incandescent plasma',
}

namespace :deploy do
  task :default do
    transaction do
      puts "Deploying #{release_number} to #{stage}."
      time.begin
		  make_shared_dirs
		  misc.rollback_notification # this task only exists to send notifications in case the deploy fails
		  web.disable
		  background_updater.disable
      stop
      update
      write_version_file
      top.deploy.db.reset_db_hook
      # top.deploy.tables # uncomment to pull in property data updates when Darrell says you should
      top.deploy.migrate
      top.deploy.db.functions
      top.deploy.db.test_db
      top.deploy.db.bootstrap.base unless ENV['SKIP_BOOTSTRAP']
      top.cache.clean
      start
      background_updater.enable
      web.enable
      cleanup
    end
    misc.send_success
    time.finish
  end

  require File.join(File.dirname(__FILE__), *%w[.. lib semaphore_files])
  namespace :background_updater do
    desc "[internal] disable the background updater"
    task :disable do
      on_rollback { background_updater.enable }
      run "touch #{SemaphoreFiles::DeployInProgress}"
    end
    desc "[internal] (re-)enable the background updater"
    task :enable, :on_error => :continue do
      run "rm #{SemaphoreFiles::DeployInProgress}"
    end
  end


  task :skip_bootstrap do
    ENV['SKIP_BOOTSTRAP'] = 'true'
    deploy.default
  end

  desc "Installs CMS configuration in target environment.  Override me in config/deploy/ENV.rb for special configurations!"
  task :setup_cms_config do
    run "cp #{release_path}/config/cms_config.deploy.yml #{release_path}/config/cms_config.yml"
  end

  desc "Issues a subscription request to the CMS"
  task :subscribe_to_cms do
    run "cd #{current_path} && env RAILS_ENV=#{rails_env} script/runner CmsGateway::Remote.subscribe_to_cms"
  end

  desc "create htaccess file in public folder"
  task :create_htaccess do
    run "cd #{release_path};RAILS_ENV=#{rails_env} script/build_htaccess" 
    unless remote_file_exists?("#{release_path}/public/.htaccess")
      raise 'Error: .htaccess not generated'
    end
  end
  
  desc "clear fragment cache" 
  task :clear_fragment_cache do
    run "cd #{current_path} && env RAILS_ENV=#{rails_env} rake tmp:frag:clear"
  end

end # namespace :deploy
