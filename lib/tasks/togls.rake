namespace :togls do
  task :features do
    Togls.features.each do |key, feature|
      puts feature.to_s
    end
  end
end
