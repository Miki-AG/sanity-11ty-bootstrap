import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'portfolio',
  title: 'Portfolio',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Left title', description: 'Defaults to “Recent Work”' }),
    defineField({
      name: 'invert',
      type: 'boolean',
      title: 'Swap columns (show rich text on left)',
      initialValue: false,
    }),
    defineField({
      name: 'items',
      title: 'Work items',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'image', type: 'image', title: 'Thumbnail', options: {hotspot: true} }),
          defineField({ name: 'title', type: 'string', title: 'Title', validation: r => r.required() }),
          defineField({ name: 'meta', type: 'string', title: 'Meta (e.g., date or category)' }),
          defineField({ name: 'url', type: 'url', title: 'Link URL' }),
        ],
        preview: {
          select: { title: 'title', subtitle: 'meta', media: 'image' }
        }
      }]
    }),
    defineField({ name: 'right', type: 'portableText', title: 'Right rich text' }),
  ],
  preview: {
    select: {title: 'title', count: 'items.length', invert: 'invert'},
    prepare({title, count, invert}: any) {
      const c = typeof count === 'number' ? count : 0
      return {
        title: title || 'Portfolio (Recent Work)',
        subtitle: `${c} item(s) • ${invert ? 'rich left' : 'rich right'}`
      }
    }
  }
})

