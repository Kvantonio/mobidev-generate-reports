# frozen_string_literal: true

require_relative File.join(File.dirname(__FILE__), '../../env.rb')

class Root
  def call(env)
    template = File.read(File.join(File.dirname(__FILE__), '../templates/root.erb'))
    content = ERB.new(template)
    [200, { 'Content-Type' => 'text/html' }, [content.result(binding)]]
  end
end
