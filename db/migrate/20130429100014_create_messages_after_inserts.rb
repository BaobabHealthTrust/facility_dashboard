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
                ELSE NEW.msg_type END);

            SET @desc = (SELECT CASE NEW.msg_type
                WHEN 'announcement' THEN NEW.msg_text
                WHEN 'advertisement' THEN 'Advert'
                ELSE NEW.heading END);

            INSERT INTO flow_order (order_group, src_id, src_table, description, duration, start_date, end_date)
            VALUES (@group, NEW.msg_id, 'messages', @desc, NEW.duration, NEW.start_date, NEW.end_date);

            SET @id = (SELECT LAST_INSERT_ID());

            IF @id > 0 THEN

              UPDATE flow_order SET order_id = @id WHERE id = @id;

            END IF;

        END
    SQL
  end

  def self.down
    execute <<-SQL
        DROP TRIGGER IF EXISTS `messages_after_insert`
    SQL
  end
end
