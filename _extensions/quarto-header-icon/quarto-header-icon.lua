local makeWatermark = false
local customIcons = {}

local function add_icons()
  script = "const IconifyIcon = window.customElements.get('iconify-icon');\n"
  for index, value in ipairs(customIcons) do
    txt = io.open(value, "r"):read("a")
    script = script .. 'IconifyIcon.addCollection('
    script = script .. txt .. '\n);\n'
  end

  fname = 'custom_icons.js'
  io.open(fname, 'w'):write(script):close()

  quarto.log.warning('wrote script to file')
  quarto.log.warning(script)

  folder = quarto.doc.input_file:match('.*/')
  quarto.log.warning(folder)

  quarto.doc.add_html_dependency({
    name = 'custom_icons',
    version = '0.0.0',
    scripts = { {
      path = folder .. fname,
    } }
  })
end

-- snippet hackishly copied from _extensions/mcanouil/iconify/iconify.lua
local function ensure_html_deps()
  quarto.doc.add_html_dependency({
    name = 'iconify',
    version = '2.0.0',
    scripts = { "iconify-icon.min.js" }
  })

  -- quarto.log.warning('num custom icons:')
  -- quarto.log.warning(#customIcons)
  -- if #customIcons > 1 then
  --   add_icons()
  -- end
end



function Meta(m)
  if m.header_icon ~= nil then
    if m.header_icon.make_watermark ~= nil then
      makeWatermark = m.header_icon.make_watermark
    end
    if m.header_icon.custom_icons ~= nil then
      quarto.log.warning('found custom')
      for index, value in ipairs(m.header_icon.custom_icons) do
        quarto.log.warning(value)
        fname = pandoc.utils.stringify(value)
        table.insert(customIcons, fname)
      end
      add_icons()
    end
  end

  quarto.log.warning(customIcons)
  return m
end

function Header(el)
  if (el.attributes and el.attributes.ico) then
    ico_code = el.attributes.ico
    ico_string = "<iconify-icon inline icon=\"" .. ico_code .. "\"></iconify-icon>&nbsp;"
    ico = pandoc.RawInline("html", ico_string)

    el.content:insert(1, ico)

    -- if (el.level==1) then
    --   quarto.log.warning(el)
    -- end
  end
  return el
end

function Span(el)
  -- if (el.classes:includes("iconify")) then
  --   ico_code = el.text
  --   ico_string = "<iconify-icon icon=\""..ico_code.."\"></iconify-icon>&nbsp;"
  --   ico = pandoc.RawInline("html",ico_string)
  --   return ico
  -- end
  if (el.attributes and el.attributes.ico) then
    ico_code = el.attributes.ico
    ico_string = "<iconify-icon inline icon=\"" .. ico_code .. "\"></iconify-icon>&nbsp;"
    ico = pandoc.RawInline("html", ico_string)

    el.content:insert(1, ico)

    -- if (el.level==1) then
    --   quarto.log.warning(el)
    -- end
  end
  return el
end

---Add icon as background watermark to RevealJS slide
---@param doc pandoc.Doc
---@return pandoc.Doc
function Pandoc(doc)
  offset = 1
  divs = pandoc.List()
  indices = pandoc.List()

  if makeWatermark == false then
    return doc
  end

  for index, block in ipairs(doc.blocks) do
    if block.attributes then
      if block.attributes.ico then
        if block.level then
          if (block.level ~= 1) then
            ico_code = block.attributes.ico
            ico_string = "<iconify-icon icon=\"" .. ico_code .. "\" height=\"80vh\"></iconify-icon>"
            if block.attributes.nowater == nil then
              ico = pandoc.RawInline("html", ico_string)

              -- d = pandoc.Div(ico)
              d = pandoc.Span(ico)

              d.classes:insert("watermark")
              d.classes:insert("hcenter")
              d.classes:insert("vcenter")

              divs:insert(d)

              indices:insert(index + offset)
              offset = offset + 1
            end
          end
        end
      end
    end
    -- quarto.log.warning(block.t)
  end

  if #indices > 0 then
    for i = 1, #indices, 1 do
      doc.blocks:insert(indices[i], divs[i])
    end
  end

  return doc
end

return {
  { Meta = Meta },
  { ensure_html_deps() },
  {
    Header = Header,
    Span = Span,
    Pandoc = Pandoc
  },
}
