-- PDF-only layout. All CV content continues to come from the Markdown pages.
local function latex(inlines)
  return (pandoc.write(pandoc.Pandoc({pandoc.Plain(inlines)}), 'latex'):gsub('%s+$', ''))
end

local function text(value)
  return latex({pandoc.Str(value)})
end

local function raw(value)
  return pandoc.RawBlock('latex', value)
end

local function lines(inlines)
  local result = {pandoc.List()}
  for _, inline in ipairs(inlines) do
    if inline.t == 'LineBreak' then
      result[#result + 1] = pandoc.List()
    else
      result[#result]:insert(inline)
    end
  end
  while #result > 1 and #result[#result] == 0 do
    table.remove(result)
  end
  return result
end

local function dated(value)
  -- The pages use "role/degree/award, Mon YYYY - ...".
  return value:match('^(.-),%s+(%a%a%a %d%d%d%d.*)$')
end

local function dates(value)
  return text(value:gsub(' %- ', ' – '))
end

function Pandoc(doc)
  local output, references = pandoc.List(), {}
  local section = ''
  local function flush_references()
    if #references > 0 then
      output:insert(raw('\\noindent\n' .. table.concat(references, '\\hfill\n') .. '\\par'))
      references = {}
    end
  end

  for _, block in ipairs(doc.blocks) do
    if block.t == 'Header' and block.level == 1 then
      flush_references()
      section = pandoc.utils.stringify(block.content)
      if section == 'Technical Skills' then
        output:insert(raw('\\Needspace{6\\baselineskip}'))
      elseif section == 'References' then
        output:insert(raw('\\Needspace{10\\baselineskip}'))
      end
      output:insert(block)
    elseif block.t == 'Para' and (section == 'Education' or section == 'Research Experience') then
      local parts = lines(block.content)
      local institution, location = pandoc.utils.stringify(parts[1]):match('^(.-), (.+)$')
      local role, date = dated(pandoc.utils.stringify(parts[2] or {}))
      if institution and role and date then
        if section == 'Education' then
          local details = {text(role)}
          for i = 3, #parts do table.insert(details, latex(parts[i])) end
          table.insert(details, text(location))
          output:insert(raw('\\cvedu{' .. text(institution) .. '}{' .. dates(date) .. '}{' ..
            table.concat(details, '\\enspace\\textperiodcentered\\enspace ') .. '}'))
        else
          local details = {}
          for i = 3, #parts do table.insert(details, latex(parts[i])) end
          output:insert(raw('\\cventry{' .. text(role .. ', ' .. institution) .. '}{' .. dates(date) .. '}{' ..
            table.concat(details, '\\\\') .. '}'))
        end
      else
        output:insert(block)
      end
    elseif block.t == 'BulletList' and section == 'Research Experience' then
      output:insert(block)
      output:insert(raw('\\vspace{0.5em}'))
    elseif block.t == 'Para' and section == 'Publications' then
      output:insert(raw('{\\small\\color{softgray}' .. latex(block.content) .. '}\\par\\vspace{0.45em}'))
    elseif block.t == 'OrderedList' and section == 'Publications' then
      -- Names need only a single rule, with no line breaking inside the name.
      output:insert(block:walk({Underline = function(el)
        return pandoc.RawInline('latex', '\\underline{' .. latex(el.content) .. '}')
      end}))
    elseif block.t == 'Para' and section == 'Technical Skills' and block.content[1].t == 'Strong' then
      local label = pandoc.utils.stringify(block.content[1].content):gsub(':$', '')
      local body = pandoc.List()
      for i = 2, #block.content do body:insert(block.content[i]) end
      output:insert(raw('\\cvskill{' .. text(label) .. '}{' .. latex(body) .. '}'))
    elseif block.t == 'BulletList' and section == 'Teaching Experience' then
      local courses = {}
      for _, item in ipairs(block.content) do
        table.insert(courses, latex(lines(item[1].content)[1]))
      end
      output:insert(raw('{\\small ' .. table.concat(courses, '\\enspace\\textperiodcentered\\enspace ') .. '}\\par'))
    elseif block.t == 'OrderedList' and section == 'Honors and Awards' then
      local items = {}
      for _, item in ipairs(block.content) do
        local label, date = dated(pandoc.utils.stringify(item))
        if label then
          table.insert(items, '\\item ' .. text(label) .. '\\hfill{\\small\\color{softgray}' .. dates(date) .. '}')
        else
          table.insert(items, '\\item ' .. pandoc.write(pandoc.Pandoc(item), 'latex'))
        end
      end
      output:insert(raw('\\begin{itemize}\n' .. table.concat(items, '\n') .. '\n\\end{itemize}'))
    elseif block.t == 'Para' and section == 'References' then
      local parts, details = lines(block.content), {}
      for i = 2, #parts do table.insert(details, latex(parts[i])) end
      table.insert(references, '\\cvref{' .. latex(parts[1]) .. '}{' .. table.concat(details, '\\\\') .. '}')
      if #references == 3 then flush_references() end
    elseif block.t ~= 'HorizontalRule' then
      output:insert(block)
    end
  end
  flush_references()
  doc.blocks = output
  return doc
end
