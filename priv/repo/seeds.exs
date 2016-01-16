# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tewdew.Repo.insert!(%Tewdew.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Tewdew.Repo.insert(%Tewdew.User{
  id: "656efe7a-27c3-49b6-a654-a793e19327c6",
  email: "pzuraq@gmail.com",
  password: "lolpassword"
})

Tewdew.Repo.insert(%Tewdew.TaskBoard{
  id: "3e4080df-0261-4ee2-be46-8658046ec6aa",
  user_id: "656efe7a-27c3-49b6-a654-a793e19327c6",
  name: "My Board"
})

Tewdew.Repo.insert(%Tewdew.TaskList{
  id: "d7a73c83-1045-4e97-adae-88203e45b61e",
  task_board_id: "3e4080df-0261-4ee2-be46-8658046ec6aa",
  name: "My List"
})

Tewdew.Repo.insert(%Tewdew.Task{
  id: "dbcfe6a5-20e7-42dd-bed4-dfa3ed80f2c7",
  task_list_id: "d7a73c83-1045-4e97-adae-88203e45b61e",
  name: "Finish Tewdew!",
  ordinal: 0,
  is_complete: false
})
