import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'adjustableImage',
  title: 'Adjustable Image',
  type: 'object',
  fields: [
    defineField({ name: 'image', type: 'image', title: 'Image', options: {hotspot: true}, validation: r => r.required() }),
    defineField({ name: 'alt', type: 'string', title: 'Alt text' }),
    defineField({
      name: 'widthPct',
      type: 'number',
      title: 'Width (%) on desktop',
      description: 'Applied from md breakpoint and up; mobile is full width',
      initialValue: 100,
      validation: r => r.min(10).max(100)
    }),
    defineField({
      name: 'align',
      type: 'string',
      title: 'Alignment (desktop)',
      options: { list: [
        {title: 'Left', value: 'left'},
        {title: 'Center', value: 'center'},
        {title: 'Right', value: 'right'},
      ], layout: 'radio', direction: 'horizontal' },
      initialValue: 'left'
    }),
    defineField({
      name: 'captionAlign',
      type: 'string',
      title: 'Caption alignment',
      options: { list: [
        {title: 'Left', value: 'left'},
        {title: 'Center', value: 'center'},
        {title: 'Right', value: 'right'},
      ], layout: 'radio', direction: 'horizontal' },
      initialValue: 'left'
    }),
    defineField({ name: 'caption', type: 'portableText', title: 'Caption (optional)' }),
  ],
  preview: {
    select: {media: 'image', a: 'align', w: 'widthPct'},
    prepare({media, a, w}: any) {
      const align = a === 'center' ? 'center' : (a === 'right' ? 'right' : 'left')
      const width = typeof w === 'number' ? `${w}%` : 'auto'
      return { title: `Image • ${align}, ${width}`, media }
    }
  }
})
