import {defineField, defineType} from 'sanity'

export default defineType({
  name: 'pricingTable',
  title: 'Pricing Table',
  type: 'object',
  fields: [
    defineField({ name: 'title', type: 'string', title: 'Title' }),
    defineField({ name: 'subtitle', type: 'portableText', title: 'Subtitle' }),
    defineField({
      name: 'plans',
      title: 'Plans',
      type: 'array',
      of: [{
        type: 'object',
        fields: [
          defineField({ name: 'name', type: 'string', title: 'Name', validation: r => r.required() }),
          defineField({ name: 'price', type: 'string', title: 'Price', description: 'Example: $29' }),
          defineField({ name: 'period', type: 'string', title: 'Period', description: 'Example: /mo' }),
          defineField({ name: 'features', title: 'Features', type: 'portableText', description: 'Use bullet list items for plan features.' }),
          defineField({ name: 'highlight', type: 'boolean', title: 'Highlight plan' }),
          defineField({ name: 'buttonLabel', type: 'string', title: 'Button label', initialValue: 'Get started' }),
          defineField({ name: 'buttonUrl', type: 'url', title: 'Button URL' }),
        ]
      }]
    })
  ],
  preview: {
    select: {title: 'title', count: 'plans.length'},
    prepare({title, count}: any) {
      return { title: title || 'Pricing Table', subtitle: count ? `${count} plan(s)` : 'No plans' }
    }
  }
})
