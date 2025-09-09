<template>
  <div 
    id="app" 
    class="min-h-screen bg-gradient-to-br from-dark-950 via-dark-900 to-dark-950"
  >
    <div class="container mx-auto px-4 py-8">
      <PasswordGenerator ref="passwordGenerator" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import PasswordGenerator from './components/PasswordGenerator.vue'

const passwordGenerator = ref()
</script>