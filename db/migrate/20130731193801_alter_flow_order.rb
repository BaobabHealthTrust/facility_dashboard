class AlterFlowOrder < ActiveRecord::Migration

    def self.up

      change_table :flow_order do |t|
        t.change :order_group, "ENUM('facility attendance', 'area attendance', " +
            "'facility services', 'announcement', 'facility indicators', " +
            "'facility alert', 'educational messages', 'advertisement', 'trends', "+
            "'catchment areas', 'public health messages', 'notice board', 'admission figures', 'adt overview')", :default => nil
      end

    end

    def self.down
      change_table :flow_order do |t|
        t.change :order_group, "ENUM('facility attendance', 'area attendance', " +
            "'facility services', 'announcement', 'facility indicators', " +
            "'facility alert', 'educational messages', 'advertisement', 'trends', "+
            "'catchment areas', 'public health messages', 'notice board', 'admission figures')", :default => nil

      end
    end



end
