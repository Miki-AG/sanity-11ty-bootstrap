import {defineConfig} from 'sanity'
import {schemaTypes} from './schemaTypes'

export default defineConfig({
  name: 'default',
  title: 'Landing Pages Studio',
  projectId: '__SANITY_PROJECT_ID__',
  dataset: '__SANITY_DATASET__',
  schema: {
    types: schemaTypes,
  },
})
