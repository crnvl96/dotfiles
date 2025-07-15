local function retrieve_llm_key(key_name)
  local filepath = NVIM_DIR .. '/.env'
  local file = io.open(filepath, 'r')

  if not file then return nil end

  for line in file:lines() do
    line = line:match('^%s*(.-)%s*$')

    if line ~= '' and not line:match('^#') then
      local eq_pos = line:find('=')
      if eq_pos then
        local current_key = line:sub(1, eq_pos - 1)
        local current_value = line:sub(eq_pos + 1)

        current_key = current_key:match('^%s*(.-)%s*$')
        current_value = current_value:match('^%s*(.-)%s*$')

        if current_key == key_name then
          file:close()
          return current_value
        end
      end
    end
  end

  file:close()

  return nil
end

MiniDeps.later(function()
  local function build_mcp(params)
    vim.notify('Building mcphub.nvim', vim.log.levels.INFO)

    local obj = vim.system({ 'npm', 'install', '-g', 'mcp-hub@latest' }, { cwd = params.path }):wait()

    if obj.code == 0 then
      vim.notify('Building mcphub.nvim done', vim.log.levels.INFO)
    else
      vim.notify('Building mcphub.nvim failed', vim.log.levels.ERROR)
    end
  end

  MiniDeps.add({
    source = 'ravitemer/mcphub.nvim',
    hooks = {
      post_install = build_mcp,
      post_checkout = build_mcp,
    },
  })

  MiniDeps.add('olimorris/codecompanion.nvim')

  require('mcphub').setup({
    config = vim.fn.expand(NVIM_DIR .. '/mcp-servers.json'),
  })

  require('codecompanion').setup({
    opts = {
      --       system_prompt = function()
      --         return [[You are an agent - please keep going until the user’s query is completely resolved, before ending your turn and yielding back to the user.
      --
      -- Your thinking should be thorough and so it's fine if it's very long. However, avoid unnecessary repetition and verbosity. You should be concise, but thorough.
      --
      -- You MUST iterate and keep going until the problem is solved.
      --
      -- I want you to fully solve this autonomously before coming back to me.
      --
      -- Only terminate your turn when you are sure that the problem is solved and all items have been checked off. Go through the problem step by step, and make sure to verify that your changes are correct. NEVER end your turn without having truly and completely solved the problem, and when you say you are going to make a tool call, make sure you ACTUALLY make the tool call, instead of ending your turn.
      --
      -- Always tell the user what you are going to do before making a tool call with a single concise sentence. This will help them understand what you are doing and why.
      --
      -- If the user request is "resume" or "continue" or "try again", check the previous conversation history to see what the next incomplete step in the todo list is. Continue from that step, and do not hand back control to the user until the entire todo list is complete and all items are checked off. Inform the user that you are continuing from the last incomplete step, and what that step is.
      --
      -- Take your time and think through every step - remember to check your solution rigorously and watch out for boundary cases, especially with the changes you made. Your solution must be perfect. If not, continue working on it. At the end, you must test your code rigorously using the tools provided, and do it many times, to catch all edge cases. If it is not robust, iterate more and make it perfect. Failing to test your code sufficiently rigorously is the NUMBER ONE failure mode on these types of tasks; make sure you handle all edge cases, and run existing tests if they are provided.
      --
      -- You MUST plan extensively before each function call, and reflect extensively on the outcomes of the previous function calls. DO NOT do this entire process by making function calls only, as this can impair your ability to solve the problem and think insightfully.
      --
      -- # Workflow
      --
      -- 1. Understand the problem deeply. Carefully read the issue and think critically about what is required.
      -- 2. Investigate the codebase. Explore relevant files, search for key functions, and gather context.
      -- 3. Develop a clear, step-by-step plan. Break down the fix into manageable, incremental steps. Display those steps in a simple todo list using standard markdown format. Make sure you wrap the todo list in triple backticks so that it is formatted correctly.
      -- 4. Implement the fix incrementally. Make small, testable code changes.
      -- 5. Debug as needed. Use debugging techniques to isolate and resolve issues.
      -- 6. Test frequently. Run tests after each change to verify correctness.
      -- 7. Iterate until the root cause is fixed and all tests pass.
      -- 8. Reflect and validate comprehensively. After tests pass, think about the original intent, write additional tests to ensure correctness, and remember there are hidden tests that must also pass before the solution is truly complete.
      --
      -- Refer to the detailed sections below for more information on each step.
      --
      -- ## 1. Deeply Understand the Problem
      -- Carefully read the issue and think hard about a plan to solve it before coding.
      --
      -- ## 2. Codebase Investigation
      -- - Explore relevant files and directories.
      -- - Search for key functions, classes, or variables related to the issue.
      -- - Read and understand relevant code snippets.
      -- - Identify the root cause of the problem.
      -- - Validate and update your understanding continuously as you gather more context.
      --
      -- ## 3. Fetch Provided URLs
      -- - If the user provides a URL, use the `functions.fetch_webpage` tool to retrieve the content of the provided URL.
      -- - After fetching, review the content returned by the fetch tool.
      -- - If you find any additional URLs or links that are relevant, use the `fetch_webpage` tool again to retrieve those links.
      -- - Recursively gather all relevant information by fetching additional links until you have all the information you need.
      --
      -- ## 4. Develop a Detailed Plan
      -- - Outline a specific, simple, and verifiable sequence of steps to fix the problem.
      -- - Create a todo list in markdown format to track your progress.
      -- - Each time you complete a step, check it off using `[x]` syntax.
      -- - Each time you check off a step, display the updated todo list to the user.
      -- - Make sure that you ACTUALLY continue on to the next step after checkin off a step instead of ending your turn and asking the user what they want to do next.
      --
      -- ## 5. Making Code Changes
      -- - Before editing, always read the relevant file contents or section to ensure complete context.
      -- - Always read 2000 lines of code at a time to ensure you have enough context.
      -- - If a patch is not applied correctly, attempt to reapply it.
      -- - Make small, testable, incremental changes that logically follow from your investigation and plan.
      --
      -- ## 6. Debugging
      -- - Make code changes only if you have high confidence they can solve the problem
      -- - When debugging, try to determine the root cause rather than addressing symptoms
      -- - Debug for as long as needed to identify the root cause and identify a fix
      -- - Use the #problems tool to check for any problems in the code
      -- - Use print statements, logs, or temporary code to inspect program state, including descriptive statements or error messages to understand what's happening
      -- - To test hypotheses, you can also add test statements or functions
      -- - Revisit your assumptions if unexpected behavior occurs.
      --
      -- # Fetch Webpage
      -- Use the `fetch_webpage` tool when the user provides a URL. Follow these steps exactly.
      --
      -- 1. Use the `fetch_webpage` tool to retrieve the content of the provided URL.
      -- 2. After fetching, review the content returned by the fetch tool.
      -- 3. If you find any additional URLs or links that are relevant, use the `fetch_webpage` tool again to retrieve those links.
      -- 4. Go back to step 2 and repeat until you have all the information you need.
      --
      -- IMPORTANT: Recursively fetching links is crucial. You are not allowed skip this step, as it ensures you have all the necessary context to complete the task.
      --
      -- # How to create a Todo List
      -- Use the following format to create a todo list:
      -- ```markdown
      -- - [ ] Step 1: Description of the first step
      -- - [ ] Step 2: Description of the second step
      -- - [ ] Step 3: Description of the third step
      -- ```
      --
      -- Do not ever use HTML tags or any other formatting for the todo list, as it will not be rendered correctly. Always use the markdown format shown above.
      --
      -- # Creating Files
      -- Each time you are going to create a file, use a single concise sentence inform the user of what you are creating and why.
      --
      -- # Reading Files
      -- - Read 2000 lines of code at a time to ensure that you have enough context.
      -- - Each time you read a file, use a single concise sentence to inform the user of what you are reading and why.]]
      --       end,
    },
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true,
          make_vars = true,
          make_slash_commands = true,
        },
      },
    },
    strategies = {
      -- [X] anthropic
      -- [ ] openai
      -- [ ] deepseek
      -- [ ] xai
      -- [ ] venice
      chat = {
        adapter = 'venice',
        keymaps = { completion = { modes = { i = '<C-n>' } } },
        slash_commands = {
          file = { opts = { provider = 'fzf_lua' } },
          buffer = { opts = { provider = 'fzf_lua' } },
        },
      },
    },
    adapters = {
      openai = function()
        return require('codecompanion.adapters').extend('openai', {
          env = { api_key = retrieve_llm_key('OPENAI_API_KEY') },
          schema = { model = { default = 'gpt-4.1' } },
        })
      end,
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = retrieve_llm_key('ANTHROPIC_API_KEY'),
          },
          schema = {
            model = {
              default = 'claude-sonnet-4-20250514',
            },
          },
        })
      end,
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = { api_key = retrieve_llm_key('GEMINI_API_KEY') },
          schema = { model = { default = 'gemini-2.5-pro-preview-05-06' } },
        })
      end,
      deepseek = function()
        return require('codecompanion.adapters').extend('deepseek', {
          env = {
            api_key = retrieve_llm_key('DEEPSEEK_API_KEY'),
          },
          schema = {
            model = {
              default = 'deepseek-chat',
            },
          },
        })
      end,
      xai = function()
        return require('codecompanion.adapters').extend('xai', {
          env = {
            api_key = retrieve_llm_key('XAI_API_KEY'),
          },
          schema = {
            model = {
              default = 'grok-3',
            },
          },
        })
      end,
      venice = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          name = 'venice',
          formatted_name = 'Venice',
          env = {
            url = 'https://api.venice.ai/api',
            chat_url = '/v1/chat/completions',
            api_key = retrieve_llm_key('VENICE_API_KEY'),
          },
          schema = {
            model = {
              default = 'mistral-31-24b',
            },
            temperature = {
              order = 2,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.8,
              desc = 'What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic. We generally recommend altering this or top_p but not both.',
              validate = function(n) return n >= 0 and n <= 2, 'Must be between 0 and 2' end,
            },
            max_completion_tokens = {
              order = 3,
              mapping = 'parameters',
              type = 'integer',
              optional = true,
              default = nil,
              desc = 'An upper bound for the number of tokens that can be generated for a completion.',
              validate = function(n) return n > 0, 'Must be greater than 0' end,
            },
            presence_penalty = {
              order = 4,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0,
              desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.",
              validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
            },
            top_p = {
              order = 5,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0.9,
              desc = 'A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)',
              validate = function(n) return n >= 0 and n <= 1, 'Must be between 0 and 1' end,
            },
            stop = {
              order = 6,
              mapping = 'parameters',
              type = 'string',
              optional = true,
              default = nil,
              desc = 'Sets the stop sequences to use. When this pattern is encountered the LLM will stop generating text and return. Multiple stop patterns may be set by specifying multiple separate stop parameters in a modelfile.',
              validate = function(s) return s:len() > 0, 'Cannot be an empty string' end,
            },
            frequency_penalty = {
              order = 8,
              mapping = 'parameters',
              type = 'number',
              optional = true,
              default = 0,
              desc = "Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.",
              validate = function(n) return n >= -2 and n <= 2, 'Must be between -2 and 2' end,
            },
            logit_bias = {
              order = 9,
              mapping = 'parameters',
              type = 'map',
              optional = true,
              default = nil,
              desc = 'Modify the likelihood of specified tokens appearing in the completion. Maps tokens (specified by their token ID) to an associated bias value from -100 to 100. Use https://platform.openai.com/tokenizer to find token IDs.',
              subtype_key = {
                type = 'integer',
              },
              subtype = {
                type = 'integer',
                validate = function(n) return n >= -100 and n <= 100, 'Must be between -100 and 100' end,
              },
            },
          },
          roles = {
            llm = 'assistant',
            user = 'user',
          },
          opts = {
            stream = true,
          },
          features = {
            text = true,
            tokens = true,
            vision = false,
          },
        })
      end,
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<Leader>ca', '<cmd>CodeCompanionActions<cr>')
  vim.keymap.set({ 'n', 'v' }, '<Leader>cc', '<cmd>CodeCompanionChat Toggle<cr>')
  vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<cr>')
end)
