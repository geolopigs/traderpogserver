class CreateGameInfos < ActiveRecord::Migration
  def change
    create_table :game_infos do |t|
      t.datetime :lastupdated

      t.timestamps
    end
  end
end
