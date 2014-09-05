require 'state_machine'

module Mint
  class Client
    class StateMachine < DelegateClass(Mint::Client)

      state_machine :state, initial: :landing_page do
        state :landing_page

        state :login
        state :login_loading
        state :logging_in
        
        state :overview
        state :overview_loading

        state :transactions
        state :transactions_loading

        navigation_states = %i(overview transactions)
        navigation_loading_states = navigation_states.map {|s| "#{s}_loading".to_sym }

        event(:navigate_to_login) { transition :landing_page => :login_loading }
        event(:navigated_to_login) { transition :login_loading => :login }

        event(:login) { transition :login => :logging_in }
        event(:logged_in) { transition :logging_in => :overview_loading }

        event(:navigate_to_overview) { transition navigation_states => :overview_loading }
        event(:navigated_to_overview) { transition :overview_loading => :overview }

        event(:navigate_to_transactions) { transition navigation_states => :transactions_loading }
        event(:navigated_to_transactions) { transition :transactions_loading => :transactions }

        after_transition :to => :login_loading, do: -> (c,ev) { c.visit_login }

        after_transition :to => :logging_in, do: -> (c,ev) { c.perform_login }
        after_transition any => navigation_loading_states + %i(login_loading), do: -> (c,ev) { c.load_page(ev.to) }

        after_transition :to => :overview, do: -> (c,ev) { c.load_alerts }
        after_transition :to => :overview, do: -> (c,ev) { c.load_accounts }

        after_transition :to => :transactions, do: -> (c,ev) { c.load_accounts }
        after_transition :to => :transactions, do: -> (c,ev) { c.load_transactions }

        before_transition any => any, :do => :log_before_transition
        after_transition any => any, :do => :log_after_transition
      end

      def log_before_transition(event)
        logger.debug("transitioning from #{event.from} to #{event.to}")
      end

      def log_after_transition(event)
        logger.debug("transitioned from #{event.from} to #{event.to}")
      end

    end
  end
end