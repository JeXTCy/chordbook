<script setup>
import { computed } from "vue";
import * as icons from "@/icons";
import usePaginatedFetch from "@/composables/usePaginatedFetch";
import ModelAvatar from "./ModelAvatar.vue";

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
  songsheetId: {
    type: String,
    required: true,
  },
});

const { items, load } = usePaginatedFetch(`setlists/${props.id}/songsheets`);

const currentIndex = computed(() => {
  const index = items.findIndex(({ id }) => id === props.songsheetId);
  // Not found, load more and rely on reactivity to update this calculated value
  if (index < 0) load();
  return index;
});

// Previous will always be loaded if current is loaded
const prev = computed(
  () => currentIndex.value >= 0 && items[currentIndex.value - 1],
);

const next = computed(() => {
  const songsheet = currentIndex.value >= 0 && items[currentIndex.value + 1];
  // Nothing found, load more and rely on reactivity to update this calculated value
  if (!songsheet) load();
  return songsheet;
});

await load();
</script>

<template>
  <data-source v-slot="{ data }" :src="`setlists/${id}`">
    <ion-footer translucent>
      <ion-toolbar class="relative flex items-center">
        <ion-buttons v-if="prev" slot="start" class="w-1/2 lg:w-1/3">
          <ion-item
            button
            class="w-full"
            lines="none"
            :router-link="{
              name: 'setlistSongsheet',
              params: { id: prev.id, setlistId: id },
            }"
            detail="false"
          >
            <model-avatar
              slot="start"
              class="hidden md:block ml-2"
              :src="prev.track?.album?.cover?.small"
              type="Songsheet"
            />
            <ion-label class="truncate">
              <p class="flex items-center gap-1">
                <ion-icon :icon="icons.playBack" size="small" />
                Previous
              </p>
              <h2 class="md:text-sm">
                {{ prev.title }}
              </h2>
            </ion-label>
          </ion-item>
        </ion-buttons>
        <ion-title
          class="hidden lg:block"
          :router-link="{ name: 'setlist', params: { id } }"
          router-direction="back"
        >
          <div class="m-2">
            <ion-note class="block text-xs uppercase tracking-wider">
              Setlist:
            </ion-note>
            {{ data.title }}
          </div>
        </ion-title>
        <ion-buttons
          v-if="next"
          slot="end"
          class="w-1/2 lg:w-1/3 flex justify-end"
        >
          <ion-item
            button
            class="w-full"
            lines="none"
            :router-link="{
              name: 'setlistSongsheet',
              params: { id: next.id, setlistId: id },
            }"
            detail="false"
          >
            <model-avatar
              slot="end"
              class="hidden sm:block"
              :src="next.track?.album?.cover?.small"
              type="Songsheet"
            />
            <ion-label class="text-right truncate text-sm">
              <p class="inline-flex items-center gap-1">
                Next
                <ion-icon :icon="icons.playNext" size="small" />
              </p>
              <h2 class="text-xs md:text-sm">
                {{ next.title }}
              </h2>
            </ion-label>
          </ion-item>
        </ion-buttons>
      </ion-toolbar>
    </ion-footer>
  </data-source>
</template>
