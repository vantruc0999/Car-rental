class HelloJob
  include Sidekiq::Job

  def perform(*args)
    # Do something
    puts "Hello iem <3 #{args[0]}"
  end
end
