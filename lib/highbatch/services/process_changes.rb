class ProcessChanges < Referential
  EXPECTED_CONTROLLERS = ['playlists'].freeze
  def initialize(file_path)
    super(file_path)
  end

  def call
    log.info 'Processing changes..'
    json.each do |controller, actions_to_process|
      controller = controller.strip
      unless EXPECTED_CONTROLLERS.include?(controller)
        raise InvalidAttributeError, "#{controller} is not a supported controller"
      end

      # allow for extensibility for other controllers
      perform_controller_actions(controller, actions_to_process)
    end
  end

  private

  def perform_controller_actions(controller_string, actions_to_process)
    controller_instance = constantize(controller_string).new
    # need to process in a specific order so we dont try to delete a playlist we are trying to add
    controller_instance.allowed_actions.each do |action|
      if(actions_to_process.has_key?(action))
        actions_to_process[action].each { |args| controller_instance.send(action, args) }
      end
    end
  end
end
