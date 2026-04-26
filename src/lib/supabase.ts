import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://jjqzxgfnadujkpqpxgbt.supabase.co';
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqcXp4Z2ZuYWR1amtwcXB4Z2J0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQyNTYxMTIsImV4cCI6MjA4OTgzMjExMn0.YUQd-7QuYiW-GyTtv34Frj2xMNFGc8laj6CQLR99oLw';

export const supabase = createClient(supabaseUrl, supabaseKey);
