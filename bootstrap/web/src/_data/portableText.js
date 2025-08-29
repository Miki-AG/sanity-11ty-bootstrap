// Minimal Portable Text to HTML renderer (no external deps)
// Supports: normal/h2/h3/h4, bullet/number lists, strong/em/code, links

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

function renderMarks(text, marks, markDefs) {
  let out = escapeHtml(text)
  if (!marks || !marks.length) return out
  // Apply in order; nesting order follows marks array
  for (const m of marks) {
    if (m === 'strong') out = `<strong>${out}</strong>`
    else if (m === 'em') out = `<em>${out}</em>`
    else if (m === 'code') out = `<code>${out}</code>`
    else {
      const def = markDefs?.find(d => d._key === m)
      if (def && def._type === 'link' && def.href) {
        const href = escapeHtml(def.href)
        const attrs = def.blank ? ' target="_blank" rel="noopener noreferrer"' : ''
        out = `<a href="${href}"${attrs}>${out}</a>`
      }
    }
  }
  return out
}

function renderBlock(block) {
  if (block._type !== 'block') return ''

  const children = (block.children || []).map(span =>
    renderMarks(span.text || '', span.marks || [], block.markDefs || [])
  ).join('')

  const style = block.style || 'normal'
  if (block.listItem) {
    // Lists are grouped outside; return li only
    return `<li>${children}</li>`
  }

  if (style === 'h2') return `<h2>${children}</h2>`
  if (style === 'h3') return `<h3>${children}</h3>`
  if (style === 'h4') return `<h4>${children}</h4>`
  return `<p>${children}</p>`
}

export function toHtml(value) {
  const blocks = Array.isArray(value) ? value : []
  let html = ''
  let i = 0
  while (i < blocks.length) {
    const b = blocks[i]
    if (b && b._type === 'block' && b.listItem) {
      const type = b.level && b.level > 1 ? 'ul' : (b.listItem === 'number' ? 'ol' : 'ul')
      let list = ''
      while (i < blocks.length && blocks[i]._type === 'block' && blocks[i].listItem) {
        list += renderBlock(blocks[i])
        i++
      }
      html += `<${type}>${list}</${type}>`
      continue
    }
    html += renderBlock(b)
    i++
  }
  return html
}

export default { toHtml }

