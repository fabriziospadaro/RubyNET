module Events
  def on(event, &proc)
    unless self.events.key? event
      raise Error, "`#{event}` is not a valid event type"
    end
    self.events[event] = proc
  end

  def create_events
    self.events.keys.each do |key|
      define_singleton_method("on_#{key}".to_sym) do |*args| # or even |*args|
        self.events[key].call(*args)
      end
    end
  end

end