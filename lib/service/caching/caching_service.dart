abstract class CachingService
{
  Object load(String key);

  void put(String key, Object data);

  void invalidate();
}