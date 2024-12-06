defmodule TaskProcessor do
  @moduledoc """
  Process list items in parallel while tracking task completion.
  """

  @doc """
  Processes items in parallel and tracks completion.
  Returns a list of {:ok, result} or {:error, reason} tuples.

  ## Examples

      iex> items = [1, 2, 3, 4, 5]
      iex> TaskProcessor.process_items(items, fn x -> x * 2 end)
      [ok: 2, ok: 4, ok: 6, ok: 8, ok: 10]

      # With progress reporting
      iex> TaskProcessor.process_items([1, 2, 3], fn x ->
      ...>   :timer.sleep(100)
      ...>   x * 2
      ...> end, fn progress -> IO.inspect(progress, label: "Progress:") end)
      [ok: 2, ok: 4, ok: 6]
  """
  def process_items(items, processor_fn, progress_fn \\ fn _ -> :ok end) do
    task_count = length(items)
    
    # Create a named process to track progress
    {:ok, progress_pid} = Agent.start_link(fn -> 0 end, name: :progress_tracker)

    try do
      # Start tasks for each item
      tasks = Enum.map(items, fn item ->
        Task.async(fn ->
          try do
            result = processor_fn.(item)
            
            # Update progress
            Agent.update(:progress_tracker, fn completed ->
              new_completed = completed + 1
              progress = floor(new_completed / task_count * 100)
              progress_fn.(progress)
              new_completed
            end)
            
            {:ok, result}
          catch
            kind, reason ->
              {:error, {kind, reason, __STACKTRACE__}}
          end
        end)
      end)

      # Await all tasks with a timeout
      Task.await_many(tasks, :infinity)
    after
      Agent.stop(progress_pid)
    end
  end

  @doc """
  Version using Task.Supervisor for better fault tolerance and cleanup.
  Requires the supervisor to be started in your application.

  ## Example:
      # In your application supervisor:
      children = [
        {Task.Supervisor, name: TaskProcessor.TaskSupervisor}
      ]
      Supervisor.start_link(children, strategy: :one_for_one)

      # Using the supervised version:
      TaskProcessor.process_items_supervised([1, 2, 3], fn x -> x * 2 end)
  """
  def process_items_supervised(items, processor_fn, progress_fn \\ fn _ -> :ok end) do
    task_count = length(items)
    
    {:ok, progress_pid} = Agent.start_link(fn -> 0 end)

    try do
      tasks = Enum.map(items, fn item ->
        Task.Supervisor.async(TaskProcessor.TaskSupervisor, fn ->
          try do
            result = processor_fn.(item)
            
            Agent.update(progress_pid, fn completed ->
              new_completed = completed + 1
              progress = floor(new_completed / task_count * 100)
              progress_fn.(progress)
              new_completed
            end)
            
            {:ok, result}
          catch
            kind, reason ->
              {:error, {kind, reason, __STACKTRACE__}}
          end
        end)
      end)

      Task.await_many(tasks, :infinity)
    after
      Agent.stop(progress_pid)
    end
  end

  @doc """
  Process items in chunks to limit concurrency.
  Useful when dealing with large lists or resource-intensive operations.

  ## Example:
      iex> items = Enum.to_list(1..100)
      iex> TaskProcessor.process_items_chunked(items, fn x -> x * 2 end, 10)
      # Processes items in chunks of 10 concurrent tasks
  """
  def process_items_chunked(items, processor_fn, chunk_size, progress_fn \\ fn _ -> :ok end) do
    total_items = length(items)
    
    {:ok, progress_pid} = Agent.start_link(fn -> 0 end)

    try do
      items
      |> Stream.chunk_every(chunk_size)
      |> Enum.flat_map(fn chunk ->
        # Process each chunk of items
        tasks = Enum.map(chunk, fn item ->
          Task.async(fn ->
            try do
              result = processor_fn.(item)
              
              Agent.update(progress_pid, fn completed ->
                new_completed = completed + 1
                progress = floor(new_completed / total_items * 100)
                progress_fn.(progress)
                new_completed
              end)
              
              {:ok, result}
            catch
              kind, reason ->
                {:error, {kind, reason, __STACKTRACE__}}
            end
          end)
        end)

        Task.await_many(tasks, :infinity)
      end)
    after
      Agent.stop(progress_pid)
    end
  end
end
