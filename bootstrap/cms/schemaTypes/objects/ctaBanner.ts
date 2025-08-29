import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'ctaBanner',
  title: 'CTA Banner',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({ name: 'text', type: 'portableText', title: 'Text' }),
    defineField({
      name: 'variant',
      type: 'string',
      title: 'Variant',
      options: { list: [
        {title: 'Primary', value: 'primary'},
        {title: 'Secondary', value: 'secondary'},
        {title: 'Light', value: 'light'},
        {title: 'Dark', value: 'dark'},
      ], layout: 'radio' },
      initialValue: 'primary'
    }),
    defineField({ name: 'buttonLabel', type: 'string', title: 'Button label', initialValue: 'Learn more' }),
    defineField({ name: 'buttonUrl', type: 'url', title: 'Button URL' }),
  ],
  preview: {
    select: {title: 'title', variant: 'variant'},
    prepare({title, variant}: any) {
      return { title: title || 'CTA Banner', subtitle: variant ? `Variant: ${variant}` : 'Variant: primary' }
    }
  }
})

