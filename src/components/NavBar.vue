<template>
  <nav>
    <ul>
      <li><router-link to="/">Home</router-link></li>
      <li><router-link to="/about">About</router-link></li>
      <li><router-link to="/contact">Contact</router-link></li>
    </ul>
  </nav>
</template>

<script>
export default {
  name: 'NavBar',
};
</script>

<style scoped>
/* Add your navigation bar styling here */
nav {
  background-color: #333;
  padding: 10px;
}

ul {
  list-style-type: none;
  display: flex;
  justify-content: space-around;
}

li {
  margin: 0 10px;
}

a {
  color: white;
  text-decoration: none;
}
</style>