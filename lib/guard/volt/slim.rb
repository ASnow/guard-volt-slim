require 'slim/erb_converter'
require "volt/slim/guard/version"
require "volt/slim/guard/mapper"
require 'guard/compat/plugin'

module Guard
  module Volt
    class Slim < ::Guard::Plugin
      # Initializes a Guard plugin.
      # Don't do any work here, especially as Guard plugins get initialized even if they are not in an active group!
      #
      # @param [Hash] options the custom Guard plugin options
      # @option options [Array<Guard::Watcher>] watchers the Guard plugin file watchers
      # @option options [Symbol] group the group this Guard plugin belongs to
      # @option options [Boolean] any_return allow any object to be returned from a watcher
      #
      def initialize(options = {})
        super
      end

      # Called once when Guard starts. Please override initialize method to init stuff.
      #
      # @raise [:task_has_failed] when start has failed
      # @return [Object] the task result
      #
      def start
      end

      # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
      #
      # @raise [:task_has_failed] when stop has failed
      # @return [Object] the task result
      #
      def stop
        logger.info "Guard::Yield - Done!"
      end

      # Called when `reload|r|z + enter` is pressed.
      # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
      #
      # @raise [:task_has_failed] when reload has failed
      # @return [Object] the task result
      #
      def reload
      end

      # Called when just `enter` is pressed
      # This method should be principally used for long action like running all specs/tests/...
      #
      # @raise [:task_has_failed] when run_all has failed
      # @return [Object] the task result
      #
      def run_all
      end

      # Called on file(s) additions that the Guard plugin watches.
      #
      # @param [Array<String>] paths the changes files or paths
      # @raise [:task_has_failed] when run_on_additions has failed
      # @return [Object] the task result
      #
      def run_on_additions(paths)
        Compiler.run paths
      end

      # Called on file(s) modifications that the Guard plugin watches.
      #
      # @param [Array<String>] paths the changes files or paths
      # @raise [:task_has_failed] when run_on_modifications has failed
      # @return [Object] the task result
      #
      def run_on_modifications(paths)
        Compiler.run paths
      end

      # Called on file(s) removals that the Guard plugin watches.
      #
      # @param [Array<String>] paths the changes files or paths
      # @raise [:task_has_failed] when run_on_removals has failed
      # @return [Object] the task result
      #
      def run_on_removals(paths)
        paths.each do |file|
          File.unlink Mapper.app_path file
        end
      end
    end
  end
end
