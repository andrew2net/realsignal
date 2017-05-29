class ChangeSignalTypeId < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=6 WHERE signal_type=2}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=7 WHERE signal_type=3}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=2 WHERE signal_type=4}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=3 WHERE signal_type=5}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=4 WHERE signal_type=6}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=5 WHERE signal_type=7}
      end
      dir.down do
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=6 WHERE signal_type=2}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=7 WHERE signal_type=3}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=2 WHERE signal_type=4}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=3 WHERE signal_type=5}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=4 WHERE signal_type=6}
        ActiveRecord::Base.connection.execute %{UPDATE recom_signals SET signal_type=5 WHERE signal_type=7}
      end
    end
  end
end
