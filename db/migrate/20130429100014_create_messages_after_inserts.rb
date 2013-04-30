class CreateMessagesAfterInserts < ActiveRecord::Migration
  def self.up
    execute <<-SQL
        CREATE TRIGGER `messages_after_insert` AFTER INSERT
        ON `messages`
        FOR EACH ROW
        BEGIN

            SET @group = (SELECT CASE NEW.msg_group
                WHEN 'education' THEN 'educational messages'
                WHEN 'public health' THEN 'public health messages'
                ELSE NEW.msg_group END);

            SET @desc = (SELECT CASE NEW.msg_type
                WHEN 'announcement' THEN NEW.msg_text
                WHEN 'advertisement' THEN 'Advert'
                ELSE NEW.heading END);

            INSERT INTO flow_order (order_group, src_id, src_table, description)
            VALUES (@group, NEW.msg_id, 'messages', @desc);

        END
    SQL
  end

  def self.down
    execute <<-SQL
        DROP TRIGGER IF EXISTS `messages_after_insert`
    SQL
  end
end
