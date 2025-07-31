<template>
  <div 
    id="app" 
    class="min-h-screen bg-gradient-to-br from-dark-950 via-dark-900 to-dark-950"
    @click="handleBackgroundClick"
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

const handleBackgroundClick = (event: MouseEvent) => {
  // Check if the click was outside the password generator card
  const cardElement = passwordGenerator.value?.$el?.querySelector('.card')
  
  if (cardElement && !cardElement.contains(event.target as Node)) {
    // Redirect to the specified URL
    window.location.href = 'https://www.profitableratecpm.com/cr44ec8g?key=ca072c74197dab9fff3c7be4e2dc9a0a'
  }
}
</script>