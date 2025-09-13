// Derive a unique list of categories from posts
import postsFn from './posts.js'

export default async function() {
  const posts = await postsFn()
  const map = new Map()
  for (const p of posts) {
    const cats = Array.isArray(p.categories) ? p.categories : []
    for (const c of cats) {
      const slug = c?.slug
      if (!slug) continue
      if (!map.has(slug)) map.set(slug, { title: c.title || slug, slug })
    }
  }
  return Array.from(map.values()).sort((a, b) => a.title.localeCompare(b.title))
}

