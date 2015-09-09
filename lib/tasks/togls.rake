namespace :togls do
  desc "Output all features including status (on, off, ? - unknown due to complex rule), key, description"
  task :features do
    Togls.features.each do |toggle|
      puts toggle.to_s
    end
  end
end
